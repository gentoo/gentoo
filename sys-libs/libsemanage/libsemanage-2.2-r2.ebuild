# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsemanage/libsemanage-2.2-r2.ebuild,v 1.3 2015/04/08 18:28:33 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_3 )

inherit multilib python-r1 toolchain-funcs eutils multilib-minimal

SEPOL_VER="2.2"
SELNX_VER="2.2.2-r1"

DESCRIPTION="SELinux kernel and policy management library"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20131030/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}
	>=sys-libs/libselinux-${SELNX_VER}
	dev-libs/ustr
	sys-process/audit"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	python? (
		>=dev-lang/swig-2.0.4-r1
		virtual/pkgconfig
		${PYTHON_DEPS}
	)"

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

src_prepare() {
	echo "# Set this to true to save the linked policy." >> "${S}/src/semanage.conf"
	echo "# This is normally only useful for analysis" >> "${S}/src/semanage.conf"
	echo "# or debugging of policy." >> "${S}/src/semanage.conf"
	echo "save-linked=false" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Set this to 0 to disable assertion checking." >> "${S}/src/semanage.conf"
	echo "# This should speed up building the kernel policy" >> "${S}/src/semanage.conf"
	echo "# from policy modules, but may leave you open to" >> "${S}/src/semanage.conf"
	echo "# dangerous rules which assertion checking" >> "${S}/src/semanage.conf"
	echo "# would catch." >> "${S}/src/semanage.conf"
	echo "expand-check=1" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Modules in the module store can be compressed" >> "${S}/src/semanage.conf"
	echo "# with bzip2.  Set this to the bzip2 blocksize" >> "${S}/src/semanage.conf"
	echo "# 1-9 when compressing.  The higher the number," >> "${S}/src/semanage.conf"
	echo "# the more memory is traded off for disk space." >> "${S}/src/semanage.conf"
	echo "# Set to 0 to disable bzip2 compression." >> "${S}/src/semanage.conf"
	echo "bzip-blocksize=0" >> "${S}/src/semanage.conf"
	echo >> "${S}/src/semanage.conf"
	echo "# Reduce memory usage for bzip2 compression and" >> "${S}/src/semanage.conf"
	echo "# decompression of modules in the module store." >> "${S}/src/semanage.conf"
	echo "bzip-small=true" >> "${S}/src/semanage.conf"

	epatch_user

	multilib_copy_sources
}

multilib_src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" all || die

	if multilib_is_native_abi && use python; then
		building() {
			python_export PYTHON_INCLUDEDIR PYTHON_LIBPATH
			emake CC="$(tc-getCC)" PYINC="-I${PYTHON_INCLUDEDIR}" PYTHONLBIDIR="${PYTHON_LIBPATH}" PYPREFIX="${EPYTHON##*/}" "$@"
		}
		python_foreach_impl building swigify
		python_foreach_impl building pywrap
	fi
}

multilib_src_install() {
	LIBDIR="\$(PREFIX)/$(get_libdir)" SHLIBDIR="\$(PREFIX)/$(get_libdir)" \
		emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		installation() {
			emake DESTDIR="${D}" install-pywrap
		}
		python_foreach_impl installation
	fi
}
