from gn_args import *
import os, sys

if len(sys.argv) != 2 :
    print("pass me a list of gn variables")
    sys.exit(1)

# Dump the configuration based on platform and environment.
configs = GetAllPlatformConfigs({})
def_args = configs["Release_GN_x64"]

os.environ['TEST_GN_DEFINES'] = sys.argv[1]
gentoo_args = ParseNameValueList(ShlexEnv('TEST_GN_DEFINES'))
os.environ.pop('TEST_GN_DEFINES')

for k,v in gentoo_args.items() :
    if k in def_args and v != def_args[k] :
        print("overwriting variable %s with different value (%s -> %s)" % (k, def_args[k], v))
