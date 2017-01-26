# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="changelog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Hash extension to make working with nested hashes easier"
HOMEPAGE="https://github.com/liufengyun/hashdiff"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""
