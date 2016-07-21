# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: obs-service.eclass
# @MAINTAINER:
# suse@gentoo.org
# @BLURB: Reduces code duplication in the Open Build Service services.
# @DESCRIPTION:
# This eclass makes it easier to package Open Build Service services. Based on
# provided information it will set all needed variables and takes care of
# installation.
#
# @EXAMPLE:
# Typical ebuild using obs-service.eclass:
#
# @CODE
# EAPI=4
#
# inherit obs-service
#
# KEYWORDS=""
#
# DEPEND=""
# RDEPEND="${DEPEND}"
#
# @CODE

# @ECLASS-VARIABLE: OBS_SERVICE_NAME
# @DESCRIPTION:
# Name of the service. If not set, it is taken from ${PN}.

# @ECLASS-VARIABLE: ADDITIONAL_FILES
# @DEFAULT_UNSET
# @DESCRIPTION:
# If any additional files are needed.

case "${EAPI:-0}" in
	4|5) : ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

HOMEPAGE="http://en.opensuse.org/openSUSE:OSC"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-util/osc
	dev-util/suse-build
"

[[ -n ${OBS_SERVICE_NAME} ]] || OBS_SERVICE_NAME=${PN/obs-service-/}
OBS_PROJECT="openSUSE:Tools"

DESCRIPTION="Open Build Service client module - ${OBS_SERVICE_NAME} service"

inherit obs-download

# As it aint versioned at all use arrows to deal with it
SRC_URI="${OBS_URI}/${OBS_SERVICE_NAME} -> ${OBS_SERVICE_NAME}-${PV}"
SRC_URI+=" ${OBS_URI}/${OBS_SERVICE_NAME}.service -> ${OBS_SERVICE_NAME}-${PV}.service"

for i in ${ADDITIONAL_FILES}; do
	SRC_URI+=" ${OBS_URI}/${i} -> ${i}-${PV}"
done

# @FUNCTION: obs-service_src_unpack
# @DESCRIPTION:
# Just copy files. Files are not compressed.
obs-service_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"
	cd "${DISTDIR}"
	mkdir -p "${S}"
	cp ${A} "${S}"
}

# @FUNCTION: obs-service_src_prepare
# @DESCRIPTION:
# Replaces all /usr/lib/build directories with /usr/share/suse-build to reflect
# where suse-build is installed in Gentoo.
obs-service_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"
	debug-print "Replacing all paths to find suse-build in Gentoo"
	find "${S}" -type f -exec \
		sed -i 's|/usr/lib/build|/usr/libexec/suse-build|g' {} +
	debug-print "Replacing all paths from hardcoded suse libexec"
	find "${S}" -type f -exec \
		sed -i 's|/usr/lib/obs|/usr/libexec/obs|g' {} +
}

# @FUNCTION: obs-service_src_install
# @DESCRIPTION:
# Does the installation of the downloaded files.
obs-service_src_install() {
	debug-print-function ${FUNCNAME} "$@"
	debug-print "Installing service \"${OBS_SERVICE_NAME}\""
	exeinto /usr/libexec/obs/service
	newexe "${S}"/${OBS_SERVICE_NAME}-${PV} ${OBS_SERVICE_NAME}
	insinto /usr/libexec/obs/service
	newins "${S}"/${OBS_SERVICE_NAME}-${PV}.service ${OBS_SERVICE_NAME}.service
	if [[ -n ${ADDITIONAL_FILES} ]]; then
		debug-print "Installing following additional files:"
		debug-print "	${ADDITIONAL_FILES}"
		exeinto /usr/libexec/obs/service/${OBS_SERVICE_NAME}.files
		for i in ${ADDITIONAL_FILES}; do
			newexe "${S}"/${i}-${PV} ${i}
		done
	fi
}

EXPORT_FUNCTIONS src_install src_prepare src_unpack
