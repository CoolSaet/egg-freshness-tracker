"""Tiny helper component that makes egg_dates.h available to lambdas."""

import esphome.codegen as cg
import esphome.config_validation as cv

CODEOWNERS = ["@CoolSaet"]

CONFIG_SCHEMA = cv.Schema({})


async def to_code(config):
    cg.add_global(cg.RawStatement('#include "esphome/components/egg_dates/egg_dates.h"'))
