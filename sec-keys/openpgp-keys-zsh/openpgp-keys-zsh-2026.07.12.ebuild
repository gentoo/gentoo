# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7CA7ECAAF06216B90F894146ACF8146CAE8CBBC4:dana:manual,ubuntu'
	'E96646BE08C0AF0AA0F90788A5FEEE3AC7937444:danielsh:manual,ubuntu'
	'29000BA887A93190F72B6D00FB52E368B70B2559:llua1:manual,ubuntu'
	'0AA945AD2FD8CF3BDD0916EE2389993190DDB2CE:llua2:manual,ubuntu'
	'F7B2754C7DE2830914661F0EA71D9A9D4BDB27B3:p.w.stephenson:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="PGP keys used to sign ZSH releases"
HOMEPAGE="https://www.zsh.org/"
SRC_URI+=" https://www.zsh.org/pub/zsh-keyring.asc -> zsh-keyring-${PV}.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
