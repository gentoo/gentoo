# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs major mode for editing Puppet manifests"
HOMEPAGE="https://github.com/voxpupuli/puppet-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/voxpupuli/${PN}"
else
	SRC_URI="https://github.com/voxpupuli/puppet-mode/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3"
SLOT="0"

DOCS=( CHANGES.md README.md )
SITEFILE="50${PN}-1-gentoo.el"

elisp-enable-tests ert test
