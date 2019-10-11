# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT=75bccbb384e6907df47ab69acdccb4536806c890

DESCRIPTION="Emacs major mode for editing Ruby code"
HOMEPAGE="https://www.ruby-lang.org/"
SRC_URI="https://github.com/ruby/elisp/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

S="${WORKDIR}/elisp-${COMMIT}"
DOCS="README"
SITEFILE="50${PN}-gentoo-2.5.0.el"
