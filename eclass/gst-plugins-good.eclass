# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gst-plugins-good.eclass,v 1.29 2012/12/02 17:16:20 eva Exp $

# @ECLASS: gst-plugins-good.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @BLURB: Manages build for invididual ebuild for gst-plugins-good.
# @DESCRIPTION:
# See gst-plugins10.eclass documentation.

GST_ORG_MODULE="gst-plugins-good"

inherit eutils gst-plugins10

case "${EAPI:-0}" in
	1|2|3|4|5)
		;;
	0)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac


if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
# -good-0.10.24 uses orc optionally instead of liboil unconditionally.
# While <0.10.24 configure always checks for liboil, it is linked to only by
# non-split plugins in gst/, so we only builddep for all old packages, and have
# a RDEPEND in old versions of media-libs/gst-plugins-good
	if [[ ${SLOT} = "0.10" ]] && ! version_is_at_least "0.10.24"; then
		DEPEND="${DEPEND} >=dev-libs/liboil-0.3.8"
	fi
fi

