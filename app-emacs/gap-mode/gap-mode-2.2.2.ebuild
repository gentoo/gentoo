# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

# There are no proper releases, so we have to track down the commit
# that last bumped the version.
COMMIT=8439c3622e1f9e2ec1a8ef21020eb55e917f4416

DESCRIPTION="Major mode for editing and running GAP programs"
HOMEPAGE="https://gitlab.com/gvol/gap-mode"
SRC_URI="https://gitlab.com/gvol/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="completion lint"

# Both company-mode and flycheck are needed to byte-compile the source.
BDEPEND="
	completion? ( app-emacs/company-mode )
	lint? (	app-emacs/flycheck )
"

# You could argue that company-mode and flycheck are not hard runtime
# dependencies because gap-company.el and gap-flycheck.el will typically
# only be loaded in company-mode or flycheck-mode, but if we want to
# support (say) `M-x load-library gap-company.el` without being crashy,
# then we'll need the corresponding company.el installed.
RDEPEND="
	${BDEPEND}
	lint? ( dev-gap/gaplint	)
"

PATCHES=( "${FILESDIR}/${P}-warnings.patch" )

SITEFILE="50${PN}-gentoo.el"

DOCS=( README.md emacs.gaprc )

src_prepare(){
	default

	if ! use completion; then
		rm gap-company.el || die
	fi

	if ! use lint; then
		rm gap-flycheck.el || die
	fi

	# This defaults to a /usr/local path and expects
	# the user to configure it.
	sed -e 's~/usr/local/algebra/bin/gap~gap~' \
		-i gap-process.el || die
}
