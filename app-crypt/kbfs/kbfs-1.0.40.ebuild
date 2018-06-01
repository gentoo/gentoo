# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Keybase Filesystem (KBFS)"
HOMEPAGE="https://keybase.io/docs/kbfs"
SRC_URI="https://github.com/keybase/kbfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="git"

DEPEND=">=dev-lang/go-1.6:0"
RDEPEND="
	app-crypt/gnupg
	sys-fs/fuse
	"

S="${WORKDIR}/src/github.com/keybase/kbfs"

src_unpack() {
	unpack "${P}.tar.gz"
	mkdir -p "$(dirname "${S}")" || die
	mv "kbfs-${PV}" "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}" \
		go build -v -x \
		-tags production \
		-o "${T}/kbfsfuse" \
		github.com/keybase/kbfs/kbfsfuse
	use git && \
		GOPATH="${WORKDIR}" \
		go build -v -x \
		-tags production \
		-o "${T}/git-remote-keybase" \
		github.com/keybase/kbfs/kbfsgit/git-remote-keybase
}

src_install() {
	dobin "${T}/kbfsfuse"
	use git && \
		dobin "${T}/git-remote-keybase"
}
