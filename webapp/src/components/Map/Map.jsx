import React, { useState, useEffect } from "react";
import {
  GoogleMap,
  useLoadScript,
  Marker,
  InfoWindow,
} from "@react-google-maps/api";
import { fetchChargerData } from "@/api/map";
import { deleteChargerData } from "@/api/charger";
import dateFormat from "dateformat";
import { fullDateAndTimeFormat } from "@/utils/constants";
import "./Map.css";
import EditChargerModal from "../AddEditChargerModal/EditChargerModal";

const libraries = ["places"];
const mapContainerStyle = {
  width: "80%",
  height: "75vh",
  position: "relative",
  zIndex: 1,
};
const center = {
  lat: 46.308849, // default latitude
  lng: 16.33885, // default longitude
};

const Map = ({ chargersUpdated, chargersUpdatedCallback }) => {
  const [chargerData, setChargerData] = useState([]);
  const [selectedCharger, setSelectedCharger] = useState(null);
  const [isEditButtonEnabled, setEditButtonEnabled] = useState(false);
  const [isEditChargerModalOpen, setIsEditChargerModalOpen] = useState(false);
  const [clickedMarker, setClickedMarker] = useState(null);

  const deleteCharger = async () => {
    if (selectedCharger) {
      await deleteChargerData(selectedCharger.chargerId);
      const updatedChargers = await fetchChargerData();
      setChargerData(updatedChargers);
      setSelectedCharger(null);
      setEditButtonEnabled(false);
    }
  };

  const openEditChargerModal = () => {
    if (selectedCharger) {
      setIsEditChargerModalOpen(true);
    }
  };

  const closeEditChargerModal = () => {
    setIsEditChargerModalOpen(false);
  };

  useEffect(() => {
    const getChargers = async () => {
      const chargers = await fetchChargerData();
      setChargerData(chargers);
    };

    getChargers();
  }, [chargersUpdated]);

  const handleMarkerClick = (charger) => {
    setSelectedCharger(charger);
    setEditButtonEnabled(true);
    setClickedMarker(charger);
  };

  const handleMarkerClose = () => {
    setSelectedCharger(null);
    setEditButtonEnabled(false);
    setClickedMarker(null);
  };

  const { isLoaded, loadError } = useLoadScript({
    googleMapsApiKey: "AIzaSyB9ut80NdYyNVey4ZWLGbeINVrIFQqoIx4",
    libraries,
  });

  const getMarkerColor = (charger) => {
    return charger.active ? getOccupancyColor(charger) : "red";
  };

  const getOccupancyColor = (charger) => {
    return charger.occupied ? "blue" : "green";
  };

  if (loadError) {
    return <div>Error loading maps</div>;
  }

  if (!isLoaded) {
    return <div>Loading maps</div>;
  }

  return (
    <div>
      <GoogleMap
        mapContainerStyle={mapContainerStyle}
        zoom={14}
        center={center}
      >
        {chargerData.map((charger) => (
          <Marker
            key={charger.chargerId}
            position={{ lat: charger.latitude, lng: charger.longitude }}
            onClick={() => handleMarkerClick(charger)}
            icon={{
              url: `https://maps.google.com/mapfiles/ms/icons/${getMarkerColor(
                charger
              )}-dot.png`,
              scaledSize: new window.google.maps.Size(40, 40),
            }}
          />
        ))}

        {selectedCharger && (
          <InfoWindow
            position={{
              lat: selectedCharger.latitude,
              lng: selectedCharger.longitude,
            }}
            onCloseClick={() => handleMarkerClose()}
          >
            <div>
              <h3>{selectedCharger.name}</h3>
              <p>
                {dateFormat(selectedCharger.lastsync, fullDateAndTimeFormat)}
              </p>
              <p>{selectedCharger.active ? "Active" : "Not active"}</p>
              <p>{selectedCharger.occupied ? "Occupied" : "Not occupied"}</p>
            </div>
          </InfoWindow>
        )}
      </GoogleMap>
      <button
        className="button-styleA"
        onClick={openEditChargerModal}
        disabled={!isEditButtonEnabled}
      >
        Edit charging station
      </button>
      {isEditChargerModalOpen && (
        <div className="modal-overlay">
          <EditChargerModal
            charger={selectedCharger}
            onClose={closeEditChargerModal}
            chargersUpdatedCallback={chargersUpdatedCallback}
          />
        </div>
      )}
      <button
        className="button-styleA"
        onClick={deleteCharger}
        disabled={!isEditButtonEnabled}
      >
        Delete charging station
      </button>
    </div>
  );
};

export default Map;
