# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mono-env.eclass
# @MAINTAINER:
# dotnet@gentoo.org
# @BLURB: Set environment variables commonly used by dotnet packages.
# @DESCRIPTION:
# Set environment variables commonly used by dotnet packages.

SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

EXPORT_FUNCTIONS pkg_setup

if [[ ! ${_MONO_ENV} ]]; then

mono-env_pkg_setup() {
	# >=mono-0.92 versions using mcs -pkg:foo-sharp require shared memory, so we set the
	# shared dir to ${T} so that ${T}/.wapi can be used during the install process.
	export MONO_SHARED_DIR="${T}"

	# export more variables as needed by other dotnet packages
	export MONO_REGISTRY_PATH="${T}/registry"
	export XDG_DATA_HOME="${T}/data"

	# Building mono, nant and many other dotnet packages is known to fail if LC_ALL
	# variable is not set to C. To prevent this all mono related packages will be
	# build with LC_ALL=C (see bugs #146424, #149817)
	export LC_ALL=C

	# Monodevelop-using applications need this to be set or they will try to create config
	# files in the user's ~ dir.
	export XDG_CONFIG_HOME="${T}"

	# Fix bug 83020:
	# "Access Violations Arise When Emerging Mono-Related Packages with MONO_AOT_CACHE"
	unset MONO_AOT_CACHE

	# mono libs can live on /usr/lib as they are not arch specific
	QA_MULTILIB_PATHS="usr/lib/"
}

_MONO_ENV=1
fi
