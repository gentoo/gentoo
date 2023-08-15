# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A library for changing configuration files"
HOMEPAGE="http://augeas.net/"
SRC_URI="https://github.com/hercules-team/augeas/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
	sys-libs/readline:="
DEPEND="${RDEPEND}"
BDEPEND="
	>=app-doc/NaturalDocs-1.40
	virtual/pkgconfig
	test? ( dev-lang/ruby )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# selinux needs to be implemented
	econf --without-selinux
}

src_compile() {
	addpredict /usr/share/NaturalDocs/Config/Languages.txt
	addpredict /usr/share/NaturalDocs/Config/Topics.txt

	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
