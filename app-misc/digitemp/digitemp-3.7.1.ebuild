# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Temperature logging and reporting using Maxim's iButtons and 1-Wire protocol"
HOMEPAGE="https://www.digitemp.com/ https://www.ibutton.com/"
SRC_URI="https://github.com/bcl/digitemp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="ds9097 ds9097u ds2490"

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
	default

	sed -i \
		-e "/^CFLAGS/s:-O2:${CFLAGS}:" \
		-e "/^LIBS/s:=:= ${LDFLAGS}:" \
		Makefile || die

	# default is to compile to the ds9097u.
	if ! ( use ds9097 || use ds9097u || use ds2490 ); then
		ewarn "If you don't choose a component to install, we default to ds9097u"
	fi
}

src_compile() {
	local targets=$(targets)

	for target in ${targets}; do
		emake clean
		emake CC="$(tc-getCC)" LOCK="no" ${target}
	done
}

src_install() {
	for target in $(echo $(targets) | tr '[:lower:]' '[:upper:]'); do
		dobin digitemp_${target} && \
		dosym digitemp_${target} /usr/bin/digitemp
	done

	if [[ $(targets|wc -l) -ge 1 ]]; then
		ewarn "/usr/bin/digitemp has been symlinked to /usr/bin/digitemp_${target}"
		ewarn "If you want to access the others, they are available at /usr/bin/digitemp_*"
	fi

	dodoc README FAQ TODO

	for example in perl python rrdb; do
		docinto ${example}_examples
		dodoc -r ${example}/*
	done
}

pkg_postinst() {
	elog "Examples of using digitemp with python, perl, and rrdtool are"
	elog "located in /usr/share/doc/${PF}/"
}
