# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: emboss-r1.eclass
# @MAINTAINER:
# sci-biology@gentoo.org
# jlec@gentoo.org
# ted.tanberry@gmail.com
# @AUTHOR:
# Original author: Author Olivier Fisette <ofisette@gmail.com>
# Next gen author: Justin Lecher <jlec@gentoo.org>
# Next gen author: Ted Tanberry <ted.tanberry@gmail.com>
# @BLURB: Use this to easy install EMBOSS and EMBASSY programs (EMBOSS add-ons).
# @DESCRIPTION:
# The inheriting ebuild must set at least EAPI=5 and provide EBO_DESCRIPTION before the inherit line.
# KEYWORDS should be set. Additionally "(R|P)DEPEND"encies and other standard
# ebuild variables can be extended (FOO+=" bar").
#
# Example:
#
# EAPI="5"
#
# EBO_DESCRIPTION="applications from the CBS group"
#
# inherit emboss-r1

# @ECLASS-VARIABLE: EBO_DESCRIPTION
# @DEFAULT_UNSET
# @DESCRIPTION:
# Should be set. Completes the generic description of the embassy module as follows:
#
# EMBOSS integrated version of ${EBO_DESCRIPTION}, e.g.
#
# "EMBOSS integrated version of applications from the CBS group"
#
# Defaults to the upstream name of the module.

# @ECLASS-VARIABLE: EBO_EXTRA_ECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra config options passed to econf.

case ${EAPI:-0} in
	5) ;;
	*) die "this eclass doesn't support < EAPI 5" ;;
esac

inherit autotools-utils eutils flag-o-matic

HOMEPAGE="http://emboss.sourceforge.net/"
LICENSE="LGPL-2 GPL-2"

SLOT="0"
IUSE="mysql pdf png postgres static-libs X"

DEPEND="
	dev-libs/expat
	dev-libs/libpcre:3
	sci-libs/plplot
	sys-libs/zlib
	mysql? ( virtual/mysql )
	pdf? ( media-libs/libharu )
	png? ( media-libs/gd[png] )
	postgres? ( dev-db/postgresql:= )
	X? ( x11-libs/libXt )"
RDEPEND="${DEPEND}"

if [[ ${PN} == embassy-* ]]; then
	EMBASSY_PACKAGE=yes
	# The EMBASSY package name, retrieved from the inheriting ebuild's name
	EN=${PN:8}
	# The full name and version of the EMBASSY package (excluding the Gentoo
	# revision number)
	EF=$(echo ${EN} | tr "[:lower:]" "[:upper:]")-${PV}
	: ${EBO_DESCRIPTION:=${EN}}
	DESCRIPTION="EMBOSS integrated version of ${EBO_DESCRIPTION}"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/${EF}.tar.gz -> embassy-${EN}-${PVR}.tar.gz"
	DEPEND+=" >=sci-biology/emboss-6.6.0[mysql=,pdf=,png=,postgres=,static-libs=,X=]"

	S="${WORKDIR}"/${EF}
fi

# @FUNCTION: emboss-r1_src_prepare
# @DESCRIPTION:
# Does the following things
#
#  1. Renames configure.in to configure.ac, if possible
#  2. Applies ${PATCHES[@]} and runs autotools via autotools-utils.eclass
#

emboss-r1_src_prepare() {
	if [[ -e configure.in ]]; then
		mv configure.{in,ac} || die
	fi

	autotools-utils_src_prepare
}

# @FUNCTION: emboss-r1_src_configure
# @DESCRIPTION:
# runs econf with following options.
#
#  $(use_with X x)
#  $(use_with png pngdriver)
#  $(use_with pdf hpdf)
#  $(use_with mysql mysql)
#  $(use_with postgres postgresql)
#  $(use_enable static-libs static)
#  --enable-large
#  --without-java
#  --enable-systemlibs
#  ${EBO_EXTRA_ECONF}

emboss-r1_src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(use_with png pngdriver "${EPREFIX}/usr")
		$(use_with pdf hpdf "${EPREFIX}/usr")
		$(use_with mysql mysql "${EPREFIX}/usr/bin/mysql_config")
		$(use_with postgres postgresql "${EPREFIX}/usr/bin/pg_config")
		--enable-large
		--without-java
		--enable-systemlibs
		${EBO_EXTRA_ECONF}
	)

	[[ ${EMBASSY_PACKAGE} == yes ]] && \
		append-cppflags "-I${EPREFIX}/usr/include/emboss"

	autotools-utils_src_configure
}

EXPORT_FUNCTIONS src_prepare src_configure
