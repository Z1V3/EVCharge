﻿using backend.Services;
using Microsoft.AspNetCore.Mvc;
using backend.Models.request;

namespace backend.Controllers
{
    [Route("api/card")]
    [ApiController]
    public class CardController : ControllerBase
    {
        private readonly CardService _cardService;
        public CardController(CardService cardService)
        {
            _cardService = cardService;
        }

        [HttpGet("getUserCards/{userID}")]
        public async Task<IActionResult> GetUserCards(int userID)
        {
            try
            {
                var cards = await _cardService.GetCardsByUserId(userID);
                if (cards == null || cards.Count == 0)
                {
                    return NotFound(new { Message = "No cards found for this user" });
                }

                return Ok(cards);
            }
            catch
            {
                return StatusCode(500, "Internal Server Error");
            }
        }

        [HttpPost("addNewCard")]
        public async Task<IActionResult> AddNewCard([FromBody] cardAddRequest cardAddReq)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var existingCard = await _cardService.GetCardByValue(cardAddReq.Value);
                if(existingCard != null)
                {
                    return Conflict(new { Message = "Card with that value already exists" });
                }

                var newCard = await _cardService.AddNewCard(cardAddReq.Value, cardAddReq.UserID.Value);

                if (newCard != null)
                {
                    return Ok(new { Message = "New card added" });
                }

                return StatusCode(422, new { Message = "Card not added" });
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }
        [HttpGet("authenticateCard/{cardValue}")]
        public async Task<IActionResult> AuthenticateCard(string cardValue)
        {
            try
            {
                var authenticatedCard = await _cardService.AuthenticateCard(cardValue);
                if (authenticatedCard == null)
                {
                    return NotFound(new { Message = "The card wasn't found or is inactive" });
                }
                var response = new
                {
                    userID = authenticatedCard.UserId
                };

                return Ok(response);
            }
            catch
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }
    }
}
