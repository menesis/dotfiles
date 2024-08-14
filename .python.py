# -*- coding: UTF-8 -*-

# Leave some useful imports
import datetime
from datetime import date, time, timedelta, timezone
try:
    from dateutil.relativedelta import relativedelta
except ImportError:
    pass
import decimal
import os
import pathlib
from pathlib import Path
import re
import sys
import math

# Utility functions
def percent(x, digits=2):
    return round(x * 100, digits)
