# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: emboss-r2.eclass
# @MAINTAINER:
# sci-biology@gentoo.org
# ted.tanberry@gmail.com
# @AUTHOR:
# Original author: Author Olivier Fisette <ofisette@gmail.com>
# Next gen author: Justin Lecher <jlec@gentoo.org>
# Next gen author: Ted Tanberry <ted.tanberry@gmail.com>
# @SUPPORTED_EAPIS: 7
# @BLURB: Use this to easy install EMBOSS and EMBASSY programs (EMBOSS add-ons).
# @DESCRIPTION:
# The inheriting ebuild must provide EBO_DESCRIPTION before the inherit line.
#
# Example:
#
# EAPI=7
#
# EBO_DESCRIPTION="applications from the CBS group"
#
# inherit emboss-r2

# @ECLASS-VARIABLE: EBO_DESCRIPTION
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Completes the generic description of the embassy module as follows:
#
# EMBOSS integrated version of ${EBO_DESCRIPTION}, e.g.
#
# "EMBOSS integrated version of applications from the CBS group"
#
# Defaults to the upstream name of the module.

case ${EAPI:-0} in
	[0-6]) die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}" ;;
	7)     ;;
	*)     die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

EXPORT_FUNCTIONS src_prepare src_configure src_install

if [[ ! ${_EMBOSS_R2_ECLASS} ]]; then
_EMBOSS_R2_ECLASS=1

inherit autotools flag-o-matic

HOMEPAGE="http://emboss.sourceforge.net/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
IUSE="mysql pdf png postgres X"

RDEPEND="
	dev-libs/expat
	dev-libs/libpcre:3
	sci-libs/plplot:=
	sys-libs/zlib
	mysql? ( dev-db/mysql-connector-c:0= )
	pdf? ( media-libs/libharu:= )
	png? ( media-libs/gd:2=[png] )
	postgres? ( dev-db/postgresql:= )
	X? ( x11-libs/libXt )"

if [[ ${PN} == embassy-* ]]; then
	EMBASSY_PACKAGE=yes
	# The EMBASSY package name, retrieved from the inheriting ebuild's name
	EN=${PN:8}
	# The full name and version of the EMBASSY package (excluding the Gentoo
	# revision number)
	EF="${EN^^}-${PV}"

	[[ ${EBO_DESCRIPTION} ]] || die "EBO_DESCRIPTION was not set before inheriting emboss-r2.eclass"

	DESCRIPTION="EMBOSS integrated version of ${EBO_DESCRIPTION}"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/${EF}.tar.gz -> embassy-${EN}-${PV}.tar.gz"
	RDEPEND+=" >=sci-biology/emboss-6.6.0-r1[mysql=,pdf=,png=,postgres=,X=]"

	S="${WORKDIR}/${EF}"
fi

DEPEND="${RDEPEND}"

# @ECLASS-VARIABLE: EBO_EAUTORECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, run eautoreconf from autotools.eclass after applying patches
# in emboss-r2_src_prepare.

# @FUNCTION: emboss-r2_src_prepare
# @DESCRIPTION:
# Does the following things
#
#  1. Renames configure.in to configure.ac, if possible
#  2. Calls default_src_prepare (i.e. applies Gentoo and user patches)
#  3. If EBO_EAUTORECONF is set, run eautoreconf

emboss-r2_src_prepare() {
	if [[ -e configure.in ]]; then
		mv configure.{in,ac} || die
	fi

	default
	[[ ${EBO_EAUTORECONF} ]] && eautoreconf
}

# @FUNCTION: emboss-r2_src_configure
# @DESCRIPTION:
# runs econf with following options.
#
#  --enable-shared
#  --disable-static
#  $(use_with X x)
#  $(use_with png pngdriver)
#  $(use_with pdf hpdf)
#  $(use_with mysql mysql)
#  $(use_with postgres postgresql)
#  --enable-large
#  --without-java
#  --enable-systemlibs
#
#  can be appended to like econf, e.g.
#    emboss-r2_src_configure --enable-foo

emboss-r2_src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
		$(use_with X x)
		$(use_with png pngdriver "${EPREFIX}"/usr)
		$(use_with pdf hpdf "${EPREFIX}"/usr)
		$(use_with mysql mysql "${EPREFIX}"/usr/bin/mysql_config)
		$(use_with postgres postgresql "${EPREFIX}"/usr/bin/pg_config)
		--enable-large
		--without-java
		--enable-systemlibs
	)

	[[ ${EMBASSY_PACKAGE} == yes ]] && \
		append-cppflags "-I${EPREFIX}/usr/include/emboss"

	econf "${myconf[@]}" "$@"
}

# @FUNCTION: emboss-r2_src_install
# @DESCRIPTION:
# Installs the package into the staging area and removes unnecessary .la files.

emboss-r2_src_install() {
	default

	# delete .la files
	find "${ED}" -name '*.la' -delete || die
}

fi
