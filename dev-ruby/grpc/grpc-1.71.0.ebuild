# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTENSIONS=(src/ruby/ext/grpc/extconf.rb)
RUBY_FAKEGEM_EXTRAINSTALL="etc src"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit multiprocessing ruby-fakegem

DESCRIPTION="Send RPCs from Ruby using GRPC"
HOMEPAGE="https://github.com/grpc/grpc"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/googleapis-common-protos-types:1
	=dev-ruby/google-protobuf-4*
"

each_ruby_configure() {
	export GRPC_RUBY_BUILD_PROCS="$(makeopts_jobs)"

	each_fakegem_configure
}

each_ruby_install() {
	# Remove all the "src" bits that are not needed
	rm -rf src/core src/ruby/spec src/ruby/ext/grpc/{libs,objs} || die

	each_fakegem_install
}
