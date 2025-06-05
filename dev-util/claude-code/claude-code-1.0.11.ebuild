# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

DESCRIPTION="Claude Code - an agentic coding tool by Anthropic"
HOMEPAGE="https://www.anthropic.com/claude-code"
SRC_URI="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${PV}.tgz"
S="${WORKDIR}"

# NOTE(JayF): claude-code is only usable via paid subscription and has a
#             clickthrough EULA-type license. Please see $HOMEPAGE for
#             full details.
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/lib64/node_modules/@anthropic-ai/claude-code/vendor/*"
RESTRICT="strip"

RDEPEND="
	>=net-libs/nodejs-18
	sys-apps/ripgrep
"
BDEPEND=">=net-libs/nodejs-18[npm]"

src_unpack() {
	# npm installs the tarball directly
	:
}

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	local -a my_npm_opts=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}/usr"
		--progress false
		--verbose
	)
	edo npm "${my_npm_opts[@]}" install "${DISTDIR}/${P}.tgz"

	rm -r "${ED}/usr/lib64/node_modules/@anthropic-ai/claude-code/vendor/ripgrep" || die
	insinto /etc/claude-code
	doins "${FILESDIR}/policies.json"
}
