# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Keybase Filesystem (KBFS)"
HOMEPAGE="https://keybase.io/docs/kbfs"
EGIT_REPO_URI="https://github.com/keybase/kbfs.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/go-1.6:0
	>=app-crypt/keybase-1.0.17
	"
RDEPEND="
	app-crypt/gnupg
	sys-fs/fuse
	"


S="${WORKDIR}/src/github.com/keybase/kbfs"

src_unpack() {
	git-r3_src_unpack
	mkdir -p "$(dirname "${S}")" || die
	ln -s "${WORKDIR}/${P}" "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}" \
		go build -v -x \
		-tags production \
		-o "${T}/kbfsfuse" \
		github.com/keybase/kbfs/kbfsfuse
}

src_install() {
	dobin "${T}/kbfsfuse"
}
