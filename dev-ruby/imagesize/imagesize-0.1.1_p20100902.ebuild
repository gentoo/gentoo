# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/imagesize/imagesize-0.1.1_p20100902.ebuild,v 1.5 2014/05/15 01:03:45 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

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
