# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_BASE_PV="$(replace_all_version_separators '-' $(get_version_component_range 1-3))"
MY_PV="${MY_BASE_PV}.v$(get_version_component_range 4)"

DESCRIPTION="A Genomic Mapping and Alignment Program for mRNA and EST Sequences"
HOMEPAGE="http://research-pub.gene.com/gmap/"
SRC_URI="http://research-pub.gene.com/gmap/src/gmap-gsnap-${MY_PV}.tar.gz"

LICENSE="gmap"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/gmap-${MY_BASE_PV}"
