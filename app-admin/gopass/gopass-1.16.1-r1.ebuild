# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature

DESCRIPTION="a simple but powerful password manager for the terminal"
HOMEPAGE="https://www.gopass.pw/"
SRC_URI="https://github.com/gopasspw/gopass/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	app-alternatives/gpg
	dev-vcs/git
"
BDEPEND="
	>=dev-lang/go-1.24.1
	sys-apps/which
"

src_prepare() {
	default

	# remove stripping & buildvcs from Makefile
	sed -e '/ldflags/s/-s //g' \
		-e '/buildvcs/s/-buildvcs=true //g' \
		-i Makefile || die

	# Broken on dates other than 2023-01-07
	sed -e 's/TestHTML/_&/' -i internal/audit/output_test.go || die
	# Trying to use gpg-agent fails in Portage tests
	sed -e 's/TestCloneCheckDecryptionKeys/_&/' -i internal/action/clone_test.go || die
	# Broken with portage env vars
	sed -e 's/TestEnvVarsInDocs/_&/' -i internal/config/docs_test.go || die
	# Flaky test (bug #891219)
	sed -e 's/TestSet/_&/' -i internal/store/leaf/write_test.go || die
}

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
