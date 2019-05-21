# Material UI MDX Example

This is an simple example for custom styled MDX.

We will integrate MDX with following modules:

- [Create React App](https://facebook.github.io/create-react-app/) for build environment
- [Material UI v4](https://next.material-ui.com/) components
- Syntax highlighted with [Prism](https://prismjs.com/)

## Guide

### Initial React App

Execute following command to create a React app:

```bash
npx create-react-app my-app
cd my-app
```

### Install MDX

Execute following command to install `mdx.macro`:

```bash
yarn add mdx.macro
```

Then create the following `src/App.js`:

```jsx
// src/App.js
import React, { lazy, Suspense } from 'react';
import { importMDX } from 'mdx.macro';

const Content = lazy(() => importMDX('./Content.mdx'));

const App = () => (
  <div>
    <Suspense fallback={<div>Loading...</div>}>
      <Content />
    </Suspense>
  </div>
);

export default App;
```

And then create the following `src/Content.mdx`:

```md
# Hello, world!
```

[🔗 Reference: Getting Started - Create React App](https://mdxjs.com/getting-started/create-react-app)

### Setup Material UI

Install Material UI:

```bash
yarn add -D @material-ui/core@next
```

Add [CSS Baseline](https://material-ui.com/style/css-baseline/):

```diff
  import React, { lazy, Suspense } from 'react';
  import { importMDX } from 'mdx.macro';
+ import CssBaseline from '@material-ui/core/CssBaseline';

  const Content = lazy(() => importMDX('./Content.mdx'));

  const App = () => (
-   <div>
-     <Suspense fallback={<div>Loading...</div>}>
-       <Content />
-     </Suspense>
-   </div>
+   <>
+     <CssBaseline />
+     <div>
+       <Suspense fallback={<div>Loading...</div>}>
+         <Content />
+       </Suspense>
+     </div>
+   </>
  );

  export default App;
```

### Initial MDX Provider

Import `MDXProvider`:

```diff
  import React, { lazy, Suspense } from 'react';
  import { importMDX } from 'mdx.macro';
  import CssBaseline from '@material-ui/core/CssBaseline';
+ import { MDXProvider } from '@mdx-js/tag';
+ import components from './components';

  const Content = lazy(() => importMDX('./Content.mdx'));

  const App = () => (
    <>
      <CssBaseline />
-     <div>
-       <Suspense fallback={<div>Loading...</div>}>
-         <Content />
-       </Suspense>
-     </div>
+     <MDXProvider components={components}>
+       <div>
+         <Suspense fallback={<div>Loading...</div>}>
+           <Content />
+         </Suspense>
+       </div>
+     </MDXProvider>
    </>
  );

  export default App;
```

**Notice**: if you use [`mdx-loader`](https://mdxjs.com/getting-started/webpack#webpack), you might have to use [`@mdx-js/react`](https://mdxjs.com/getting-started/#mdxprovider) instead.

Set components:

```jsx
// src/components.js
import React, { memo } from 'react';
import Typography from '@material-ui/core/Typography';

const components = {
  h1: (() => {
    const H1 = props => <Typography {...props} component="h1" variant="h1" />;
    return memo(H1);
  })(),
};

export default components;
```

You can see that your contents with MDX are applied Material UI components now.

Try to customize all components. You can check [the table of components](https://mdxjs.com/getting-started#table-of-components) to know the tags to change. You can also [customize the wrapper](https://mdxjs.com/guides/wrapper-customization#using-the-wrapper-for-layout).

You can use the [`markdown-it`](https://markdown-it.github.io/) [demo code](./src/Content.mdx) to preview the result.

### Syntax Highlighted

You can use `prism-react-renderer` directly:

```bash
yarn add prism-react-renderer
```

Create a `CodeBlock` component:

```jsx
// src/CodeBlock.js
import React from 'react';
import Highlight, { defaultProps } from 'prism-react-renderer';
export default ({ children, className }) => {
  const language = className.replace(/language-/, '');
  return (
    <Highlight {...defaultProps} code={children} language={language}>
      {({ className, style, tokens, getLineProps, getTokenProps }) => (
        <pre className={className} style={{ ...style, padding: '20px' }}>
          {tokens.map((line, i) => (
            <div key={i} {...getLineProps({ line, key: i })}>
              {line.map((token, key) => (
                <span key={key} {...getTokenProps({ token, key })} />
              ))}
            </div>
          ))}
        </pre>
      )}
    </Highlight>
  );
};
```

Add `CodeBlock` to `MDXProvider`:

```diff
  import React, { memo } from 'react';
  import Typography from '@material-ui/core/Typography';
+ import CodeBlock from './CodeBlock';

  const components = {
    h1: (() => {
      const H1 = props => <Typography {...props} component="h1" variant="h1" />;
      return memo(H1);
    })(),
+   code: CodeBlock,
  };

  export default components;
```

You can use syntax highlighted code block now!

- Pros: easy
- Cons: Prism components are not split

You can customized your own `CodeBlock` with code splitting like [this](./src/CodeBlock.js). It will load only main prism at start and load other components only if they are required. The code would be highlighted after the required prism components loaded.

## Summary

You can check the completed components [here](./src/components.js).
