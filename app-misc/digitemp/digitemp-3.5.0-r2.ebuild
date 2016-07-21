# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Temperature logging and reporting using Dallas Semiconductor's iButtons and 1-Wire protocol"
HOMEPAGE="http://www.digitemp.com/ http://www.ibutton.com/"
SRC_URI="http://www.digitemp.com/software/linux/${P}.tar.gz"

IUSE="ds9097 ds9097u ds2490"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="ds2490? ( virtual/libusb:0 )"

targets() {
	# default is to compile to the ds9097u.
	if ! ( use ds9097 || use ds9097u || use ds2490 ); then
		echo ds9097u
	fi
	for target in ds9097 ds9097u ds2490; do
		if use ${target}; then
			echo ${target}
		fi
	done
}

src_prepare() {
	sed -i -e "/^CFLAGS/s:-O2:${CFLAGS}:" \
		-e "/^LIBS/s:=:= ${LDFLAGS}:" Makefile
	# default is to compile to the ds9097u.
	if ! ( use ds9097 || use ds9097u || use ds2490 ); then
		ewarn "If you don't choose a component to install, we default to ds9097u"
	fi
}

src_compile() {
	local targets=$(targets)

	for target in $targets; do
		emake clean
		emake CC="$(tc-getCC)" 	LOCK="no" ${target} || die "emake ${target} failed"
	done
}

src_install() {
	for target in $(echo $(targets) | tr '[:lower:]' '[:upper:]'); do
		dobin digitemp_${target} && \
		dosym digitemp_${target} /usr/bin/digitemp
	done

	if [[ $(targets|wc -l) -ge 1 ]]; then
		echo
		ewarn "/usr/bin/digitemp has been symlinked to /usr/bin/digitemp_${target}"
		ewarn "If you want to access the others, they are available at /usr/bin/digitemp_*"
		echo
	fi

	dodoc README FAQ TODO

	for example in perl python rrdb; do
		insinto "/usr/share/doc/${PF}/${example}_examples"
		doins -r ${example}/*
	done
}

pkg_postinst() {
	echo
	elog "Examples of using digitemp with python, perl, and rrdtool are"
	elog "located in /usr/share/doc/${PF}/"
	echo
}
