# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library for changing configuration files"
HOMEPAGE="http://augeas.net/"
SRC_URI="http://download.augeas.net/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
	sys-libs/readline:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=app-doc/NaturalDocs-1.40
	test? ( dev-lang/ruby )"

PATCHES=(
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# selinux needs to implemented
	econf \
		--without-selinux \
		$(use_enable static-libs static)
}

src_compile() {
	addpredict /usr/share/NaturalDocs/Config/Languages.txt
	addpredict /usr/share/NaturalDocs/Config/Topics.txt
	default
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -delete || die
}
