import React, { Fragment, useState } from "react";
import { useQuery } from "graphql-hooks";

export default function EntryPage() {
  return (
    <div className="row mb-4">
      <div className="col-6 col-lg-4">
        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/lSXpV8bDeMA/1536x2304"
            data-width="1536"
            data-height="2304"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/lSXpV8bDeMA/416x623"
            />
          </a>
          <figcaption>
            <h6>Rocky mountain under blue and white sky</h6>
            <a href="https://unsplash.com/photos/lSXpV8bDeMA">
              Photo by Guillaume Briard
            </a>
          </figcaption>
        </figure>

        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/ty4X72BSsXY/1279x853"
            data-width="1279"
            data-height="853"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/ty4X72BSsXY/416x278"
            />
          </a>
          <figcaption>
            <h6>Vaihingen an der Enz, Germany</h6>
            <a href="https://unsplash.com/photos/ty4X72BSsXY">
              Photo by Oliver Roos
            </a>
          </figcaption>
        </figure>
      </div>
      <div className="col-6 col-lg-4">
        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/QkPb5g9p338/1279x719"
            data-width="1279"
            data-height="719"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/QkPb5g9p338/416x234"
            />
          </a>
          <figcaption>
            <h6>Closeup photo of world globe</h6>
            <a href="https://unsplash.com/photos/QkPb5g9p338">
              Photo by chuttersnap
            </a>
          </figcaption>
        </figure>

        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/z55CR_d0ayg/1279x853"
            data-width="1279"
            data-height="853"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/z55CR_d0ayg/416x278"
            />
          </a>
          <figcaption>
            <h6>Blessed are the curious, for they shall have adventures. 🚩</h6>
            <a href="https://unsplash.com/photos/z55CR_d0ayg">
              Photo by Andrew Neel
            </a>
          </figcaption>
        </figure>

        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/IbLZjKcelpM/1020x858"
            data-width="1020"
            data-height="858"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/IbLZjKcelpM/416x350"
            />
          </a>
          <figcaption>
            <h6>Man holding pair of ski poles in front of trees</h6>
            <a href="https://unsplash.com/photos/IbLZjKcelpM">
              Photo by Oziel Gómez
            </a>
          </figcaption>
        </figure>
      </div>
      <div className="col-6 col-lg-4 d-none d-lg-block">
        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/KgCbvOWYuU0/1279x870"
            data-width="1279"
            data-height="870"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/KgCbvOWYuU0/416x283"
            />
          </a>
          <figcaption>
            <h6>Aerial photo of person using paddleboard</h6>
            <a href="https://unsplash.com/photos/KgCbvOWYuU0">
              Photo by Ishan @seefromthesky
            </a>
          </figcaption>
        </figure>

        <figure>
          <a
            className="d-block mb-4"
            data-fancybox="images"
            href="https://source.unsplash.com/O7qK1vQY3p0/1519x2279"
            data-width="1519"
            data-height="2279"
          >
            <img
              className="img-fluid"
              src="https://source.unsplash.com/O7qK1vQY3p0/416x623"
            />
          </a>
          <figcaption>
            <h6>Car on curve road surrounded by trees</h6>
            <a href="https://unsplash.com/photos/O7qK1vQY3p0">
              Photo by Grant Porter
            </a>
          </figcaption>
        </figure>
      </div>
    </div>
  );
}
