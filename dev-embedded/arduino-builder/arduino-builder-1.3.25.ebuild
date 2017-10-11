# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils golang-build

EGO_PN="arduino.cc/builder/..."

DESCRIPTION="A command line tool for compiling Arduino sketches"
HOMEPAGE="https://github.com/arduino/arduino-builder"
SRC_URI="https://github.com/arduino/${PN}/archive/${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-devel/crossdev
	>=dev-util/ctags-5.8_p20160314"

DEPEND=">=dev-lang/go-1.4.3
	dev-go/errors
	dev-go/testify
	dev-go/go-junit-report"

src_prepare() {
	./fmt_fix_vet || die
	epatch "${FILESDIR}"/platform.patch
}

src_compile() {
	golang-build_src_compile

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build -v -work -x ${EGO_BUILD_FLAGS} arduino.cc/arduino-builder
	echo "$@"
	"$@" || die
}

src_install() {
	golang-build_src_install

	dobin arduino-builder

	insinto "/usr/share/${PN}"

	doins -r src/arduino.cc/builder/hardware/*
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
