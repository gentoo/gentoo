# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/setools/setools-3.3.8-r5.ebuild,v 1.4 2015/07/28 14:55:25 jlec Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit autotools java-pkg-opt-2 python-r1 eutils toolchain-funcs

DESCRIPTION="SELinux policy tools"
HOMEPAGE="http://www.tresys.com/selinux/selinux_policy_tools.shtml"
SRC_URI="http://oss.tresys.com/projects/setools/chrome/site/dists/${P}/${P}.tar.bz2
	http://dev.gentoo.org/~swift/patches/setools/${P}-01-fedora-patches.tar.gz
	http://dev.gentoo.org/~swift/patches/setools/${P}-03-gentoo-patches.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X debug java python"

DEPEND=">=sys-libs/libsepol-2.1.4
	>=sys-libs/libselinux-2.3
	sys-devel/bison
	sys-devel/flex
	>=dev-db/sqlite-3.2:3
	dev-libs/libxml2:2
	virtual/pkgconfig
	java? (
		dev-lang/swig:1
		>=virtual/jdk-1.4
	)
	python? (
		${PYTHON_DEPS}
		dev-lang/swig:1
	)
	X? (
		>=dev-lang/tk-8.4.9
		>=gnome-base/libglade-2.0
		>=x11-libs/gtk+-2.8:2
	)"

RDEPEND=">=sys-libs/libsepol-2.1.4
	>=sys-libs/libselinux-2.3
	>=dev-db/sqlite-3.2:3
	dev-libs/libxml2:2
	java? ( >=virtual/jre-1.4 )
	X? (
		>=dev-lang/tk-8.4.9:0=
		>=dev-tcltk/bwidget-1.8
		>=gnome-base/libglade-2.0
		>=x11-libs/gtk+-2.8:2
	)"

RESTRICT="test"
# setools dirs that contain python code to build
PYTHON_DIRS="libapol/swig/python libpoldiff/swig/python libqpol/swig/python libseaudit/swig/python libsefs/swig/python python"

pkg_setup() {
	if use java; then
		java-pkg-opt-2_pkg_setup
	fi
}

src_prepare() {
	EPATCH_MULTI_MSG="Applying various (Fedora-provided) setools fixes... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}" \
	EPATCH_FORCE="yes" \
	epatch

	EPATCH_MULTI_MSG="Applying various (Gentoo) setool fixes... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/gentoo-patches" \
	EPATCH_FORCE="yes" \
	epatch

	# Disable broken check for SWIG version.
	sed -e "s/AC_PROG_SWIG(2.0.0)/AC_PROG_SWIG/" -i configure.ac || die "sed failed"
	# Use swig1.3
	sed -e 's/AC_PATH_PROG(\[SWIG\],\[swig\])/AC_PATH_PROG([SWIG],[swig1.3])/' -i m4/ac_pkg_swig.m4 || die "failed to set swig1.3"
	# Fix build failure due to double __init__.py installation
	sed -e "s/^wrappedpy_DATA = qpol.py \$(pkgpython_PYTHON)/wrappedpy_DATA = qpol.py/" -i libqpol/swig/python/Makefile.am || die

	local dir
	for dir in ${PYTHON_DIRS}; do
		# Python bindings are built/installed manually.
		sed -e "s/MAYBE_PYSWIG = python/MAYBE_PYSWIG =/" -i ${dir%python}Makefile.am || die "sed failed"
		# Make PYTHON_LDFLAGS replaceable during running `make`.
		sed -e "/^AM_LDFLAGS =/s/@PYTHON_LDFLAGS@/\$(PYTHON_LDFLAGS)/" -i ${dir}/Makefile.am || die "sed failed"
	done

	# temporary work around bug #424581 until automake-1.12 is stable (then
	# depend on it). Need to use MKDIR_P in the mean time for 1.12+.
	has_version ">=sys-devel/automake-1.12.1" && { find . -name 'Makefile.*' -exec sed -i -e 's:mkdir_p:MKDIR_P:g' {} +  || die; }

	eautoreconf

	# Disable byte-compilation of Python modules.
	echo '#!/bin/sh' > py-compile

	epatch_user
}

src_configure() {
	tc-ld-disable-gold #467136
	econf \
		--with-java-prefix=${JAVA_HOME} \
		--disable-selinux-check \
		--disable-bwidget-check \
		$(use_enable python swig-python) \
		$(use_enable java swig-java) \
		$(use_enable X swig-tcl) \
		$(use_enable X gui) \
		$(use_enable debug)

	# work around swig c99 issues.  it does not require
	# c99 anyway.
	sed -i -e 's/-std=gnu99//' "${S}/libseaudit/swig/python/Makefile"
}

src_compile() {
	emake

	if use python; then
		building() {
			python_export PYTHON_INCLUDEDIR
			python_export PYTHON_SITEDIR
			python_export PYTHON_LIBS
			emake \
				SWIG_PYTHON_CPPFLAGS="-I${PYTHON_INCLUDEDIR}" \
				PYTHON_LDFLAGS="${PYTHON_LIBS}" \
				pyexecdir="${PYTHON_SITEDIR}" \
				pythondir="${PYTHON_SITEDIR}" \
				-C "$1"
		}
		local dir
		for dir in ${PYTHON_DIRS}; do
			python_foreach_impl building ${dir}
		done
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use python; then
		installation() {
			python_export PYTHON_SITEDIR
			emake DESTDIR="${D}" \
				pyexecdir="${PYTHON_SITEDIR}" \
				pythondir="${PYTHON_SITEDIR}" \
				-C "$1" install
		}

		local dir
		for dir in ${PYTHON_DIRS}; do
			python_foreach_impl installation "${dir}"
		done
	fi
}
