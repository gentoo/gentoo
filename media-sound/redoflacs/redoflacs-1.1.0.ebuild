# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Bash commandline flac compressor, verifier, organizer, analyzer, retagger"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/redoflacs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-shells/bash-4
	media-libs/flac
	sys-apps/coreutils
"

# use precompiled redoflacs.1
src_compile() { :; }

src_install() {
	dobin redoflacs
	dodoc README.md
	doman redoflacs.1
}

pkg_postinst() {
	elog "Run 'redoflacs -o' to generate a new config-file (non-destructive) to take advantage of any new features."
	optfeature "creating spectrograms" media-sound/sox[png]
	optfeature "determining authenticity of FLAC files (CDDA)" media-sound/aucdtect
}
