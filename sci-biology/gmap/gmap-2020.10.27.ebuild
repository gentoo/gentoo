# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_rs 1- '-')"

DESCRIPTION="A Genomic Mapping and Alignment Program for mRNA and EST Sequences"
HOMEPAGE="http://research-pub.gene.com/gmap/"
SRC_URI="http://research-pub.gene.com/gmap/src/gmap-gsnap-${MY_PV}.tar.gz"

LICENSE="gmap"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/gmap-${MY_PV}"
PATCHES=( "${FILESDIR}"/${PN}-2020.10.27-fno-common.patch )
