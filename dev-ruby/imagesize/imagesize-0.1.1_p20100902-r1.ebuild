# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt"

RUBY_FAKEGEM_VERSION="0.1.1.20100902"

inherit ruby-fakegem

DESCRIPTION="Measure image size (GIF, PNG, JPEG, etc)"
HOMEPAGE="http://imagesize.rubyforge.org/"
COMMIT_ID="bd5be2afb088beba3f0d863cef4eac7db56ca804"
SRC_URI="https://github.com/mattheworiordan/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RUBY_S="${PN}-${COMMIT_ID}"

each_ruby_test() {
		${RUBY} -Ilib -S test/test_image_size.rb || die
}
