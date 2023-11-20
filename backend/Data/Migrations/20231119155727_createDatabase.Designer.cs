﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using backend.Models;

#nullable disable

namespace backend.Data.Migrations
{
    [DbContext(typeof(AirDBContext))]
    [Migration("20231119155727_createDatabase")]
    partial class createDatabase
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "6.0.25")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("backend.Models.Card", b =>
                {
                    b.Property<int>("CardId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("card_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("CardId"));

                    b.Property<bool>("Active")
                        .HasColumnType("boolean")
                        .HasColumnName("active");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.Property<decimal>("Value")
                        .HasPrecision(10, 2)
                        .HasColumnType("numeric(10,2)")
                        .HasColumnName("value");

                    b.HasKey("CardId");

                    b.HasIndex("UserId");

                    b.ToTable("card", (string)null);
                });

            modelBuilder.Entity("backend.Models.Charger", b =>
                {
                    b.Property<int>("ChargerId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("charger_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("ChargerId"));

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("created");

                    b.Property<int>("Creator")
                        .HasColumnType("integer")
                        .HasColumnName("creator");

                    b.Property<DateTime>("Lastsync")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("lastsync");

                    b.Property<decimal>("Latitude")
                        .HasPrecision(9, 6)
                        .HasColumnType("numeric(9,6)")
                        .HasColumnName("latitude");

                    b.Property<decimal>("Longitude")
                        .HasPrecision(9, 6)
                        .HasColumnType("numeric(9,6)")
                        .HasColumnName("longitude");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("character varying(50)")
                        .HasColumnName("name");

                    b.HasKey("ChargerId");

                    b.HasIndex("Creator");

                    b.ToTable("charger", (string)null);
                });

            modelBuilder.Entity("backend.Models.Event", b =>
                {
                    b.Property<int>("EventId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("event_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("EventId"));

                    b.Property<int>("ChargerId")
                        .HasColumnType("integer")
                        .HasColumnName("charger_id");

                    b.Property<DateTime>("Endtime")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("endtime");

                    b.Property<DateTime>("Starttime")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("starttime");

                    b.Property<int>("UserId")
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    b.Property<decimal>("Volume")
                        .HasPrecision(10, 2)
                        .HasColumnType("numeric(10,2)")
                        .HasColumnName("volume");

                    b.HasKey("EventId");

                    b.HasIndex("ChargerId");

                    b.HasIndex("UserId");

                    b.ToTable("event", (string)null);
                });

            modelBuilder.Entity("backend.Models.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("user_id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("UserId"));

                    b.Property<bool>("Active")
                        .HasColumnType("boolean")
                        .HasColumnName("active");

                    b.Property<DateTime>("Created")
                        .HasColumnType("timestamp without time zone")
                        .HasColumnName("created");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("character varying(50)")
                        .HasColumnName("email");

                    b.Property<string>("Password")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("character varying(30)")
                        .HasColumnName("password");

                    b.Property<string>("Role")
                        .IsRequired()
                        .HasMaxLength(30)
                        .HasColumnType("character varying(30)")
                        .HasColumnName("role");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("character varying(50)")
                        .HasColumnName("username");

                    b.HasKey("UserId");

                    b.HasIndex(new[] { "Email" }, "unique_email")
                        .IsUnique();

                    b.ToTable("users", (string)null);
                });

            modelBuilder.Entity("backend.Models.Card", b =>
                {
                    b.HasOne("backend.Models.User", "User")
                        .WithMany("Cards")
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("user_user_id_fk");

                    b.Navigation("User");
                });

            modelBuilder.Entity("backend.Models.Charger", b =>
                {
                    b.HasOne("backend.Models.User", "CreatorNavigation")
                        .WithMany("Chargers")
                        .HasForeignKey("Creator")
                        .IsRequired()
                        .HasConstraintName("user_user_id_fk");

                    b.Navigation("CreatorNavigation");
                });

            modelBuilder.Entity("backend.Models.Event", b =>
                {
                    b.HasOne("backend.Models.Charger", "Charger")
                        .WithMany("Events")
                        .HasForeignKey("ChargerId")
                        .IsRequired()
                        .HasConstraintName("charger_charger_id_fk");

                    b.HasOne("backend.Models.User", "User")
                        .WithMany("Events")
                        .HasForeignKey("UserId")
                        .IsRequired()
                        .HasConstraintName("user_user_id_fk");

                    b.Navigation("Charger");

                    b.Navigation("User");
                });

            modelBuilder.Entity("backend.Models.Charger", b =>
                {
                    b.Navigation("Events");
                });

            modelBuilder.Entity("backend.Models.User", b =>
                {
                    b.Navigation("Cards");

                    b.Navigation("Chargers");

                    b.Navigation("Events");
                });
#pragma warning restore 612, 618
        }
    }
}
