# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="gzip symlinks"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pigz +reference split-usr"
REQUIRED_USE="^^ ( pigz reference )"

RDEPEND="
	pigz? ( app-arch/pigz[-symlink(-)] )
	reference? ( >=app-arch/gzip-1.12-r3 )
	!<app-arch/gzip-1.12-r3
	!app-arch/pigz[symlink(-)]
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	if use pigz; then
		dosym "${usr_prefix}pigz" /bin/gzip
		dosym gzip /bin/gunzip
		dosym gzip /bin/zcat
		newman - gzip.1 <<<".so pigz.1"
	elif use reference; then
		dosym gzip-reference /bin/gzip
		# gzip uses shell wrappers rather than argv[0]
		dosym gunzip-reference /bin/gunzip
		dosym zcat-reference /bin/zcat
		newman - gzip.1 <<<".so gzip-reference.1"
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi

	newman - gunzip.1 <<<".so gzip.1"
	newman - zcat.1 <<<".so gzip.1"
}
