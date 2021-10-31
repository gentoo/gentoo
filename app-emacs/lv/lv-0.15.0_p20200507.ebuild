# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24.3"

inherit elisp

DESCRIPTION="Put semi-permanent hints in the echo area"
# This snapshot is only one commit ahead of 0.15.0 and only
# changes a single line. The line adds a (require ’cl-lib)
# to prevent emacs from erroring or warning about cl-lib
# not being available during byte compilation.
MY_COMMIT="87873d788891029d9e44fa5458321d6a05849b94"
HOMEPAGE="https://github.com/abo-abo/hydra"
SRC_URI="https://github.com/abo-abo/hydra/archive/${MY_COMMIT}.tar.gz -> hydra-${PV}.tar.gz"
S="${WORKDIR}/hydra-${MY_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # the tests target hydra and not lv, so we should skip them
SITEFILE="50lv-gentoo.el"
ELISP_REMOVE="hydra-examples.el hydra-ox.el hydra-test.el hydra.el"
