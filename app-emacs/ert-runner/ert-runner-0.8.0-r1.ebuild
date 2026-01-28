# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp edo

DESCRIPTION="Opinionated Emacs Ert testing workflow"
HOMEPAGE="https://github.com/rejeep/ert-runner.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rejeep/${PN}.el.git"
else
	SRC_URI="https://github.com/rejeep/${PN}.el/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/dash
	app-emacs/f
	app-emacs/dash
	app-emacs/shut-up
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ecukes
	)
"

ELISP_REMOVE="
	Makefile
	features/reporter.feature
"
PATCHES=(
	"${FILESDIR}/${PN}-bin-launcher-fix.patch"
)

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	# There are two "ert-runner" launchers,
	# the one in "${S}" will be installed,
	# the one in ./bin/ert-runner will be used only for tests.

	# For later install.
	sed "./bin/${PN}" \
		-e "s|@SITELISP@|${EPREFIX}${SITELISP}/${PN}|" \
		> "./${PN}.bash" \
		|| die

	# For tests.
	sed -i "./bin/${PN}" -e "s|@SITELISP@|${S}|" || die
}

src_compile() {
	elisp_src_compile
	elisp-compile ./reporters/*.el
}

src_test() {
	# Set up fake Cask for tests.
	mkdir -p "${T}/bin" || die
	cat <<-EOF >> "${T}/bin/cask" || die
	#!/usr/bin/env bash
	set -e
	if [[ "\${1}" != exec ]] ; then echo "Not a exec call!" ; exit 1 ; fi
	shift
	"\${@}"
	EOF
	chmod +x "${T}/bin/cask" || die
	local -x PATH="${T}/bin:${PATH}" || die

	edo ecukes --debug --reporter spec --script --verbose ./features
}

src_install() {
	elisp_src_install
	elisp-install "${PN}/reporters" ./reporters/*.el{,c}

	exeinto /usr/bin
	newexe "./${PN}.bash" "${PN}"
}
