# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome-python-common-r1.eclass
# @MAINTAINER:
# GNOME team <gnome@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on the work of: Arun raghaven <ford_prefect@gentoo.org>
# which in turn was based on the work of Jim Ramsay <lack@gentoo.org>
# @BLURB: Common functionality for building gnome-python* bindings
# @DESCRIPTION:
# This eclass provides python-r1 support for the GNOME2 library Python
# bindings.

: ${GNOME_ORG_MODULE:=gnome-python}
: ${GNOME_TARBALL_SUFFIX:=bz2}
: ${GNOME2_LA_PUNT:=yes}
: ${GCONF_DEBUG:=no}

# @ECLASS-VARIABLE: G_PY_BINDINGS
# @DESCRIPTION:
# The actual '--enable-<binding>' name. If multiple bindings are to
# be enabled, must be an array.
: ${G_PY_BINDINGS:=${PN%-python}}

# @ECLASS-VARIABLE: EXAMPLES
# @DEFAULT_UNSET
# @DESCRIPTION:
# The set of example files to be installed if the 'examples' USE flag
# is set.

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

inherit eutils gnome2 python-r1

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install

HOMEPAGE="http://pygtk.org/"

RESTRICT="${RESTRICT} test"

DOCS="AUTHORS ChangeLog NEWS README"

if [[ ${GNOME_ORG_MODULE} != "gnome-python" ]]; then
	DOCS="${DOCS} MAINTAINERS"
fi

RDEPEND="~dev-python/${GNOME_ORG_MODULE}-base-${PV}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

gnome-python-common-r1_src_prepare() {
	gnome2_src_prepare

	# The .pc file is installed by respective gnome-python*-base package
	sed -i '/^pkgconfig_DATA/d' Makefile.in || die "sed failed"
	sed -i '/^pkgconfigdir/d' Makefile.in || die "sed failed"
#
#	python_copy_sources
}

gnome-python-common-r1_src_configure() {
	local myconf=(
		--disable-allbindings
		"${G_PY_BINDINGS[@]/#/--enable-}"
	)

	ECONF_SOURCE=${S} \
	python_foreach_impl \
		gnome2_src_configure "${myconf[@]}" "${@}"
}

gnome-python-common-r1_src_compile() {
	python_foreach_impl default
}

gnome-python-common-r1_src_test() {
	python_foreach_impl default
}

# Do a regular gnome2 src_install and then install examples if required.
# Set the variable EXAMPLES to provide the set of examples to be installed.
# (to install a directory recursively, specify it with a trailing '/' - for
# example, foo/bar/)
gnome-python-common-r1_src_install() {
	python_foreach_impl gnome2_src_install

	if in_iuse examples && use examples; then
		docinto examples
		dodoc -r "${EXAMPLES[@]}"
	fi
}
