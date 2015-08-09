# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gpe.eclass
# @MAINTAINER:
# gpe@gentoo.org
# @AUTHOR:
# Original Authors:
# Rene Wagner <rw@handhelds.org>
# Ned Ludd <solar@gentoo.org>
# Angelo Arrifano <miknix@gentoo.org>
# EAPI->EAPI2 patch: loki_val
# multiple suggestions: Betelgeuse
# Based on gnome2.eclass and gpe.bbclass (the latter from OpenEmbedded)
# @BLURB: Provides common functionality for the G Palmtop Environment.

inherit libtool toolchain-funcs

case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS src_unpack src_compile src_install
		;;
	*)
		EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install
		;;
esac

# @ECLASS-VARIABLE: ELTCONF
# @DESCRIPTION:
# Extra options passed to elibtoolize on gnome2 eclass.
ELTCONF=""

# @ECLASS-VARIABLE: GPE_DOCS
# @DESCRIPTION:
# Documentation files to be installed with dodoc.
GPE_DOCS=""

[[ -z "${GPE_MIRROR}" ]] && GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
[[ -z "${GPE_TARBALL_SUFFIX}" ]] && GPE_TARBALL_SUFFIX="gz"
SRC_URI="${GPE_MIRROR}/${P}.tar.${GPE_TARBALL_SUFFIX}"

HOMEPAGE="http://gpe.linuxtogo.org"

IUSE="nls"
GPECONF="${GPECONF} --enable-debug=no --disable-debug"

RDEPEND=""
DEPEND="
	>=dev-util/intltool-0.29
	virtual/pkgconfig"

# @FUNCTION: gpe_src_unpack
# @DESCRIPTION:
# Unpacks and applies some required patches for GPE.
gpe_src_unpack() {
	unpack ${A}
	cd "${S}"
	has "${EAPI:-0}" 0 1 && gpe_src_prepare "$@"
}

# Do not call, use gpe_src_unpack() instead.
gpe_src_prepare() {
	# let portage handle stripping.
	# sort is needed, see #272161 .
	for file in $(find . -name 'Makefile*' | sort) ; do
		sed -i  -e s/'install -s'/'install'/g \
			-e s/'install -Ds'/'install -D'/g \
			-e 's/$(INSTALL) -s/$(INSTALL) /g' \
			-e 's;strip ;#strip ;g' \
			${file} \
			||die "Sedding ${file} failed."
	done
	[[ -f configure ]] && elibtoolize
}

# @FUNCTION: gpe_src_configure
# @DESCRIPTION:
# Configures a GPE package in a cross-compile aware environment.
gpe_src_configure() {
	tc-export CC
	[[ -f configure ]] && econf "$@" ${GPECONF}
}

# @FUNCTION: gpe_src_compile
# @DESCRIPTION:
# (Cross-)Compiles a GPE package.
gpe_src_compile() {
	tc-export CC
	has "${EAPI:-0}" 0 1 && gpe_src_configure "$@"
	emake PREFIX=/usr || die "emake failed"
}

# @FUNCTION: gpe_src_install
# @DESCRIPTION:
# Installs a GPE package in the correct way.
gpe_src_install() {
	local use_nls=yes

	use nls || use_nls=no

	if [ -f configure ]; then
		einstall "$@" || die "einstall failed"
	else
		emake STRIP=true DESTDIR=${D} PREFIX=/usr \
		     ENABLE_NLS=${use_nls} "$@" install || die "emake install failed"
	fi

	use nls || rm -rf ${D}/usr/share/locale

	# manual document installation
	if [[ "${GPE_DOCS}" ]]; then
		dodoc ${GPE_DOCS} || die "dodoc failed"
	fi
}
