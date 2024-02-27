# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *20230810 ]] && COMMIT=3029e5ab06171ca5947041e95053561e10e5ba41

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing Earthly Earthfiles"
HOMEPAGE="https://github.com/earthly/earthly-emacs/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/earthly/earthly-emacs.git"
else
	SRC_URI="https://github.com/earthly/earthly-emacs/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/earthly-emacs-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
