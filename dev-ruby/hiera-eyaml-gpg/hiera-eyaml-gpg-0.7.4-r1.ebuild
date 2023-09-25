# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A GPG backend for hiera-eyaml"
HOMEPAGE="https://github.com/voxpupuli/hiera-eyaml-gpg"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/hiera-eyaml-1.3.8:*
	>=dev-ruby/gpgme-2.0.0
"
