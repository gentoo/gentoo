# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_4 )

inherit autotools java-pkg-opt-2 python-r1 eutils toolchain-funcs

DESCRIPTION="SELinux policy tools"
HOMEPAGE="https://github.com/TresysTechnology/setools/wiki"
SRC_URI="http://oss.tresys.com/projects/setools/chrome/site/dists/${P}/${P}.tar.bz2
	https://dev.gentoo.org/~perfinion/patches/setools/${P}-04-gentoo-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"
IUSE="X debug java python"

COMMONDEPEND=">=sys-libs/libsepol-2.4
	>=sys-libs/libselinux-2.4
	>=dev-db/sqlite-3.2:3
	dev-libs/libxml2:2
	python? ( ${PYTHON_DEPS} )
	X? (
		>=dev-lang/tk-8.4.9:0=
		>=gnome-base/libglade-2.0
		>=x11-libs/gtk+-2.8:2
	)"

DEPEND="${COMMONDEPEND}
	>=sys-devel/automake-1.12.1
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	java? ( dev-lang/swig
	        virtual/jdk:= )
	python? ( dev-lang/swig )"

RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.4:= )
	X? ( >=dev-tcltk/bwidget-1.8 )"

RESTRICT="test"
# setools dirs that contain python code to build
PYTHON_DIRS="libapol/swig/python libpoldiff/swig/python libqpol/swig/python libseaudit/swig/python libsefs/swig/python python"

pkg_setup() {
	if use java; then
		java-pkg-opt-2_pkg_setup
	fi
}

src_prepare() {
	EPATCH_MULTI_MSG="Applying various (Gentoo) setool fixes... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/gentoo-patches" \
	EPATCH_FORCE="yes" \
	epatch

	epatch "${FILESDIR}"/${PN}-3.3.8-no-check-file.patch
	epatch "${FILESDIR}"/${PN}-3.3.8-policy-max.patch

	# Fix build failure due to double __init__.py installation
	sed -e "s/^wrappedpy_DATA = qpol.py \$(pkgpython_PYTHON)/wrappedpy_DATA = qpol.py/" -i libqpol/swig/python/Makefile.am || die
	# Disable broken check for SWIG version. Bug #542032
	sed -e "s/AC_PROG_SWIG(2.0.0)/AC_PROG_SWIG/" -i configure.ac || die "sed failed"

	local dir
	for dir in ${PYTHON_DIRS}; do
		# Python bindings are built/installed manually.
		sed -e "s/MAYBE_PYSWIG = python/MAYBE_PYSWIG =/" -i ${dir%python}Makefile.am || die "sed failed"
		# Make PYTHON_LDFLAGS replaceable during running `make`.
		sed -e "/^AM_LDFLAGS =/s/@PYTHON_LDFLAGS@/\$(PYTHON_LDFLAGS)/" -i ${dir}/Makefile.am || die "sed failed"
	done

	epatch_user

	eautoreconf

	# Disable byte-compilation of Python modules.
	echo '#!/bin/sh' > py-compile
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
