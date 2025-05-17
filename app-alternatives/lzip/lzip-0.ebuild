# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: clzip and pdlzip are probably eligible too
ALTERNATIVES=(
	"reference:>=app-arch/lzip-1.25"
	"plzip:app-arch/plzip"
)

inherit app-alternatives

DESCRIPTION="lzip symlinks"
KEYWORDS="~amd64"

RDEPEND="!<app-arch/lzip-1.25"

src_install() {
	case $(get_alternative) in
		reference)
			dosym "lzip-reference" /usr/bin/lzip
			newman - lzip.1 <<<".so lzip-reference.1"
			;;
		plzip)
			dosym "plzip" /usr/bin/lzip
			newman - lzip.1 <<<".so plzip.1"
			;;
	esac
}
