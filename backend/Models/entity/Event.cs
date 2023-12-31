﻿using System;
using System.Collections.Generic;

namespace backend.Models.entity
{
    public partial class Event
    {
        public int EventId { get; set; }
        public int ChargerId { get; set; }
        public DateTime Starttime { get; set; }
        public DateTime Endtime { get; set; }
        public TimeSpan ChargeTime { get; set; }
        public decimal Volume { get; set; }
        public decimal Price { get; set; }
        public int UserId { get; set; }

        public virtual Charger Charger { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
