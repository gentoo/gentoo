# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature

DESCRIPTION="a simple but powerful password manager for the terminal"
HOMEPAGE="https://www.gopass.pw/"
SRC_URI="https://github.com/gopasspw/gopass/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~ajak/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD MPL-2.0 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"

DEPEND=">=dev-lang/go-1.18"
RDEPEND="
	dev-vcs/git
	>=app-crypt/gnupg-2
"

PATCHES=(
	"${FILESDIR}/${PN}-1.15.3-skip-tests.patch"
)

src_test() {
	# https://github.com/gopasspw/gopass/blob/v1.15.3/.github/workflows/build.yml#L38
	git config --global user.name nobody || die
	git config --global user.email foo.bar@example.org || die

	default
}

src_install() {
	emake install DESTDIR="${ED}/usr"
	einstalldocs
}

pkg_postinst() {
	optfeature "browser integration" app-admin/gopass-jsonapi
	optfeature "git credentials helper" app-admin/git-credential-gopass
	optfeature "haveibeenpwnd.com integration" app-admin/gopass-hibp
	optfeature "summon secrets helper" app-admin/gopass-summon-provider
}
