package ;

import coconut.data.*;
import coconut.ui.*;
import tink.state.*;
import tink.core.*;
import js.Browser.*;

using tink.CoreApi;

class Main {
	static function main() {
		document.body.appendChild(new Root({}).toElement());
	}
}

class Root extends View {
	@:state public var data:RootData = new RootData({current: "get-started"});

	function render() '
		<div>
			<h2>Haxe/Coconut <small>documentation</small></h2>
			<nav>
				<Button data=${data} id="get-started" />
				<Button data=${data} id="coconut.data" />
				<Button data=${data} id="coconut.vdom"/>
				<Button data=${data} id="coconut.ui" />
				<Button data=${data} id="coconut.react"/>
				<Button data=${data} id="tink_hxx"/>
				<Button data=${data} id="tink_core" />
				<Button data=${data} id="tink_macro" />
				<Button data=${data} id="tink_state" />
				<Button data=${data} id="lix-pm" />
				<Button data=${data} id="haxeshim" />
			</nav>
			<div class="page"><!-- SOMETHING IS WRONG HERE ↓ -->
				<div class="leave-me-out">
				<if ${data.current == "tink_core"}>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/master/README.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/annex.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/any.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/callback.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/either.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/error.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/future.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/lazy.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/named.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/noise.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/outcome.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/pair.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/promise.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/ref.md"/><hr/>
					<Page url="https://raw.githubusercontent.com/haxetink/tink_core/gh-pages/types/signal.md"/>
				</if>
				</div>
				
				<Page visible=${data.current == "get-started"} url="https://gist.githubusercontent.com/markknol/0de2d8d05e8f3d725946eb5515cc771b/raw/79dfe05e46ab0e60460eb1ddd19a783a9975e85d/coconut.md"/>
				<Page visible=${data.current == "coconut.data"} url="https://raw.githubusercontent.com/MVCoconut/coconut.data/master/README.md"/>
				<Page visible=${data.current == "coconut.vdom"} url="https://raw.githubusercontent.com/MVCoconut/coconut.vdom/master/README.md"/>
				<Page visible=${data.current == "coconut.ui"} url="https://raw.githubusercontent.com/MVCoconut/coconut.ui/master/README.md"/>
				
				<Page visible=${data.current == "coconut.react"} url="https://raw.githubusercontent.com/MVCoconut/coconut.react/master/README.md"/>
				<Page visible=${data.current == "tink_hxx"} url="https://raw.githubusercontent.com/haxetink/tink_hxx/master/README.md"/>
				<Page visible=${data.current == "tink_macro"} url="https://raw.githubusercontent.com/haxetink/tink_macro/master/README.md"/>
				<Page visible=${data.current == "tink_state"} url="https://raw.githubusercontent.com/haxetink/tink_state/master/README.md"/>
				<Page visible=${data.current == "lix-pm"} url="https://raw.githubusercontent.com/lix-pm/lix.client/develop/README.md"/>
				<Page visible=${data.current == "haxeshim"} url="https://raw.githubusercontent.com/lix-pm/haxeshim/master/README.md"/>
			</div>
		</div>
	';
}

class RootData implements Model {
	@:editable var current:String;
}

class Button extends View {
	@:attribute var data:RootData;
	@:attribute var id:String;
	function render() '<button class=${if (data.current==id) "active" else ""} onclick=${() -> data.current = id}>$id</button>';
}

class Page extends View {
	@:attribute var url:String;
	@:attribute var visible:Bool = true;
	@:state var data:PageData = new PageData({url: this.url});

	override function afterInit(e):Void {
		super.afterInit(e);
		data.url = url;
	}
	function render() '
		<div>
			<if ${visible}>
				<switch ${data.pageContent}>
					<case ${Done(pageContent)}>
						<HtmlView content="${pageContent}"/>
					<case ${Failed(error)}>
						Error..
					<case ${Loading}>
						<div class="loader"></div>
				</switch>
			</if>
		</div>';
}

class HtmlView extends View {
	@:attribute var content:String;

	override function afterPatching(e) {
		super.afterPatching(e);
		e.innerHTML = content;
		highlighter.Highlighter.highlight(e);
	}
	override function afterInit(e) {
		super.afterInit(e);
		e.innerHTML = content;
		highlighter.Highlighter.highlight(e);
	}
	function render() '<div></div>';
}

class PageData implements Model {
	@:editable var url:String;
	function load(url:String):Promise<String> {
		return Future.async(function(cb) {
			if (url == "" || url == null) {
				cb("");
				return;
			}
			var http = new haxe.Http(url);
			http.onData = function(v) cb( Markdown.markdownToHtml(v) );
			http.onError = function(v) cb(v);
			http.request(false);
		});
	}

	@:loaded var pageContent:String = load(this.url);
}


