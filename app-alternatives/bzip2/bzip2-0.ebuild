# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bzip2 symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="lbzip2 pbzip2 +reference split-usr"
REQUIRED_USE="^^ ( lbzip2 pbzip2 reference )"

RDEPEND="
	lbzip2? ( app-arch/lbzip2[-symlink(-)] )
	pbzip2? ( app-arch/pbzip2[-symlink(-)] )
	reference? ( >=app-arch/bzip2-1.0.8-r4 )
	!<app-arch/bzip2-1.0.8-r4
	!app-arch/lbzip2[symlink(-)]
	!app-arch/pbzip2[symlink(-)]
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	if use lbzip2; then
		dosym "${usr_prefix}lbzip2" /bin/bzip2
		newman - bzip2.1 <<<".so lbzip2.1"
		newman - bunzip2.1 <<<".so lbzip2.1"
		newman - bzcat.1 <<<".so lbzip2.1"
	elif use pbzip2; then
		dosym "${usr_prefix}pbzip2" /bin/bzip2
		newman - bzip2.1 <<<".so pbzip2.1"
		newman - bunzip2.1 <<<".so pbzip2.1"
		newman - bzcat.1 <<<".so pbzip2.1"
	elif use reference; then
		dosym bzip2-reference /bin/bzip2
		newman - bzip2.1 <<<".so bzip2-reference.1"
		newman - bunzip2.1 <<<".so bzip2-reference.1"
		newman - bzcat.1 <<<".so bzip2-reference.1"
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi

	dosym bzip2 /bin/bunzip2
	dosym bzip2 /bin/bzcat
}
