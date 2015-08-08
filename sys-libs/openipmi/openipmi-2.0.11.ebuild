# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Library interface to IPMI"
HOMEPAGE="http://sourceforge.net/projects/openipmi/"
MY_PN="OpenIPMI"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE="crypt snmp perl tcl python"
S="${WORKDIR}/${MY_P}"
RESTRICT='test'

RDEPEND="dev-libs/glib
	sys-libs/gdbm
	crypt? ( dev-libs/openssl )
	snmp? ( net-analyzer/net-snmp )
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )
	tcl? ( dev-lang/tcl )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.21
	virtual/pkgconfig"
# Gui is broken!
#		python? ( tcl? ( tk? ( dev-lang/tk dev-tcltk/tix ) ) )"

# Upstream doesn't use --without properly
use_yesno() {
	yesmsg="yes"
	[ -n "$3" ] && yesmsg="$3"
	if use $1; then
		echo "--with-$2=${yesmsg}"
	else
		echo "--without-$2"
	fi
}

src_compile() {
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
	econf ${myconf} --bindir=/usr/sbin || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# bug #298250
	emake -j1 DESTDIR="${D}" install || die
	dodoc README* FAQ ChangeLog TODO doc/IPMI.pdf lanserv/README.emulator
	newdoc cmdlang/README README.cmdlang
}
