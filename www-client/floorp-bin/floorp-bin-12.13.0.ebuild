# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Floorp, a Firefox-based browser (binary release)"
HOMEPAGE="https://floorp.app/ https://github.com/Floorp-Projects/Floorp"
SRC_URI="https://github.com/Floorp-Projects/Floorp/releases/download/v${PV}/floorp-linux-x86_64.tar.xz -> floorp-${PV}-linux-x86_64.tar.xz"
S="${WORKDIR}/floorp"

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[wayland]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/pango
"

QA_PREBUILT="opt/floorp/*"

src_install() {
	local dest="/opt/floorp"

	# cp -a keeps exec bits and symlinks
	dodir "${dest%/*}"
	cp -a "${S}" "${ED}${dest}" || die
	[[ -x "${ED}${dest}/floorp" ]] || die "floorp binary not found, check tarball layout"

	dosym "${dest}/floorp" /usr/bin/floorp

	local size
	for size in 16 32 48 64 128; do
		if [[ -f "${S}/browser/chrome/icons/default/default${size}.png" ]]; then
			newicon -s ${size} "${S}/browser/chrome/icons/default/default${size}.png" floorp.png
		fi
	done

	make_desktop_entry floorp Floorp floorp \
		"Network;WebBrowser" \
		"StartupWMClass=floorp\nMimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;"
}
