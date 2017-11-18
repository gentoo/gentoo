# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple templating engine based on shell"
HOMEPAGE="https://github.com/jirutka/esh"
SRC_URI="https://github.com/jirutka/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc"

RDEPEND="virtual/awk"
DEPEND="${RDEPEND}
	doc? ( dev-ruby/asciidoctor )"

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	if use doc; then
		emake man
	fi
}

src_install() {
	local target="install-exec"
	use doc && target="install"

	emake DESTDIR="${D}" prefix="${EPREFIX}usr" $target
}
