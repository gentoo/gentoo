# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/openipmi/openipmi-2.0.18-r1.ebuild,v 1.6 2015/06/12 05:13:28 jer Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils autotools python-single-r1

DESCRIPTION="Library interface to IPMI"
HOMEPAGE="http://sourceforge.net/projects/openipmi/"
MY_PN="OpenIPMI"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc x86"
IUSE="crypt snmp perl tcl python"
S="${WORKDIR}/${MY_P}"
RESTRICT='test'

RDEPEND="
	dev-libs/glib:2
	sys-libs/gdbm
	crypt? ( dev-libs/openssl:0= )
	snmp? ( net-analyzer/net-snmp )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.21
	virtual/pkgconfig"
# Gui is broken!
#		python? ( tcl? ( tk? ( dev-lang/tk dev-tcltk/tix ) ) )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Bug #338499: The installed OpenIPMIpthread.pc depends on a non-existing
	# pthread.pc. We patch it to link -lpthread directly instead.
	epatch "${FILESDIR}/${PN}-2.0.16-pthreads.patch"
	# Bug #290763: The buildsys tries to compile+optimize the py file during
	# install, when the .so might not be been added yet. We just skip the files
	# and use python_optimize ourselves later instead.
	sed -r -i \
		-e '/INSTALL.*\.py[oc] /d' \
		-e '/install-exec-local/s,OpenIPMI.pyc OpenIPMI.pyo,,g' \
		swig/python/Makefile.{am,in}

	# Bug #298250: parallel install fix.
	sed -r -i \
		-e '/^install-data-local:/s,$, install-exec-am,g' \
		cmdlang/Makefile.{am,in}

	# We touch the .in and .am above because if we use the below, the Perl stuff
	# is very fragile, and often fails to link.
	#cd "${S}"
	#elibtoolize
	#eautoreconf
}

src_configure() {
	local myconf=""
	myconf="${myconf} `use_with snmp ucdsnmp yes`"
	myconf="${myconf} `use_with crypt openssl yes`"
	myconf="${myconf} `use_with perl perl yes`"
	myconf="${myconf} `use_with tcl tcl yes`"
	myconf="${myconf} `use_with python python yes`"

	# GUI is broken
	#use tk && use python && use !tcl && \
	#	ewarn "Not building Tk GUI because it needs both Python AND Tcl"
	#if use python && use tcl; then
	#	myconf="${myconf} `use_yesno tk tkinter yes`"
	#else
	#	myconf="${myconf} `use_yesno tk tkinter no`"
	#fi

	myconf="${myconf} --without-tkinter"
	myconf="${myconf} --with-glib --with-swig"
	# these binaries are for root!
	econf ${myconf} --bindir=/usr/sbin
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README* FAQ ChangeLog TODO doc/IPMI.pdf lanserv/README.emulator
	newdoc cmdlang/README README.cmdlang

	use python && python_optimize
}
