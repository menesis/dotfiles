# -*- coding: UTF-8 -*-

# Leave some useful imports
import datetime
from datetime import date, time, timedelta, timezone
from dateutil.relativedelta import relativedelta
import decimal
import os
import pathlib
from pathlib import Path
import re
import sys

# Utility functions
def percent(x, digits=2):
    return round(x * 100, digits)
