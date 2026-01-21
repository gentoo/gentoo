# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Claude Code - an agentic coding tool by Anthropic"
HOMEPAGE="https://www.anthropic.com/claude-code"
SRC_URI="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${PV}.tgz"
S="${WORKDIR}/package"

# NOTE(JayF): claude-code is only usable via paid subscription and has a
#             clickthrough EULA-type license. Please see $HOMEPAGE for
#             full details.
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

RESTRICT="bindist strip"

RDEPEND="
	>=net-libs/nodejs-18
	sys-apps/ripgrep
"

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	dodoc README.md LICENSE.md

	# We are using a strategy of "install everything that's left"
	# so removing these here will prevent duplicates in /opt/claude-code
	rm -f README.md LICENSE.md package.json || die
	# remove vendored ripgrep
	rm -rf vendor/ripgrep || die

	insinto /opt/${PN}
	doins -r ./*
	fperms a+x opt/claude-code/cli.js

	dodir /opt/bin
	dosym -r /opt/${PN}/cli.js /opt/bin/claude

	# https://bugs.gentoo.org/962002 indicates that Claude doesn't use
	# path to find the `rg` binary. Gross. So we symlink it into the place
	# they expect it to be. Thanks to Leo Douglas for the patch.
	if use amd64; then
		dodir /opt/${PN}/vendor/ripgrep/x64-linux
		dosym -r /usr/bin/rg /opt/${PN}/vendor/ripgrep/x64-linux/rg
	elif use arm64; then
		dodir /opt/{$PN}/vendor/ripgrep/arm64-linux
		dosym -r /usr/bin/rg /opt/${PN}/vendor/ripgrep/arm64-linux/rg
	fi

	insinto /etc/${PN}
	doins "${FILESDIR}/managed-settings.json"

	# nodejs defaults to disabling deprecation warnings when running code
	# from any path containing a node_modules directory. Since we're installing
	# outside of the realm of npm, explicitly pass an option to disable
	# deprecation warnings so it behaves the same as it does if installed via
	# npm. It's proprietary; not like Gentoo users can fix the warnings anyway.
	sed -i 's/env node/env -S node --no-deprecation/' "${ED}/opt/claude-code/cli.js"
}

pkg_preinst() {
	if test -f "${ROOT}/etc/${PN}/policies.json"; then
		mv "${ROOT}/etc/${PN}/policies.json" "${ROOT}/etc/${PN}/managed-settings.json"
	fi
}
