# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Desktop entries for handling mailto URIs with GNU Emacs"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-editors/emacs-30.1:*
	>=app-emacs/emacs-common-1.14[gui]"

pkg_postinst() {
	ewarn "Desktop entries handling mailto URIs (with Emacs 30.1 or later)"
	ewarn "are now installed by >=app-emacs/emacs-common-1.14."
	ewarn "${CATEGORY}/${PN} is deprecated and no longer installs"
	ewarn "any files, so you may safely unmerge it."
}
