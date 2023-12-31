﻿using backend.Services;
using Microsoft.AspNetCore.Mvc;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/charger")]
    [ApiController]
    public class ChargerController : ControllerBase
    {
        private readonly ChargerService _chargerService;
        public ChargerController(ChargerService chargerService)
        {
            _chargerService = chargerService;
        }

        [HttpPost("createCharger")]
        public async Task<IActionResult> CreateCharger([FromBody] chargerCreateRequest chargerCreateReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var chargerWithSameName = await _chargerService.GetChargerByName(chargerCreateReq.Name);
                if (chargerWithSameName != null)
                {
                    return Conflict(new { Message = "Charger with the same name already exists" });
                }
                var newCharger = await _chargerService.CreateNewCharger(chargerCreateReq.Name, chargerCreateReq.Latitude.Value, chargerCreateReq.Longitude.Value, chargerCreateReq.Creator.Value);

                if (newCharger != null)
                {
                    return Ok(new { Message = "New charger created" });
                }

                return Conflict(new { Message = "Charger not created" });
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

        [HttpPost("updateCharger")]
        public async Task<IActionResult> updateCharger([FromBody] chargerUpdateRequest chargerUpdateReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var updatedCharger = await _chargerService.UpdateExistingCharger(chargerUpdateReq.ChargerID.Value, chargerUpdateReq.Name, chargerUpdateReq.Latitude.Value, chargerUpdateReq.Longitude.Value, chargerUpdateReq.Active.Value);

                if (updatedCharger != null)
                {
                    return Ok(new { Message = "Charger successfully updated" });
                }

                return Conflict(new { Message = "Charger not updated" });
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

        [HttpGet("getChargersStatistics")]
        public async Task<IActionResult> GetChargersStatistics()
        {
            try
            {
                var totalNumberOfChargers = await _chargerService.GetTotalChargersCount();
                var numberOfOccupiedChargers = await _chargerService.GetOccupiedChargersCount();
                var numberOfFreeChargers = await _chargerService.GetFreeChargersCount();
                var numberOfDeactivatedChargers = await _chargerService.GetDeactivatedChargersCount();
                var response = new
                {
                    TotalNumberOfChargers = totalNumberOfChargers,
                    NumberOfOccupiedChargers = numberOfOccupiedChargers,
                    NumberOfFreeChargers = numberOfFreeChargers,
                    NumberOfDeactivatedChargers = numberOfDeactivatedChargers
                };

                return Ok(new { Message = "Statistics data successfully returned", Statistics = response });
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }

        [HttpPost("updateChargerAvailability")]
        public async Task<IActionResult> UpdateChargerAvailability([FromBody] chargerAvailabilityRequest chargerAvailabilityReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                
                var updatedCharger = await _chargerService.UpdateChargerAvailability(chargerAvailabilityReq.ChargerID.Value, chargerAvailabilityReq.Occupied.Value);
                if (updatedCharger != null)
                {
                    return Ok(new { Message = "Charger availability updated successfully"});
                }
                else
                {
                    return NotFound(new { Message = "Charger not found" });
                }
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }
    }
}
