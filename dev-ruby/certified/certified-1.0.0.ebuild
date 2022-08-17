# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ensure using OpenSSL::SSL::VERIFY_PEER and provide certificate bundle if needed"
HOMEPAGE="https://github.com/stevegraham/certified"

LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~x86"
